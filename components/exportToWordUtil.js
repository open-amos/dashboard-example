import { Document, Packer, Paragraph, TextRun, Table, TableRow, TableCell, WidthType, ImageRun, AlignmentType, BorderStyle, PageBreak } from 'docx';
import { saveAs } from 'file-saver';
import html2canvas from 'html2canvas';

export async function exportPageToWord(options = {}) {
  const {
    includeCharts = true,
    maxTableRows = 100
  } = options;

  try {
    // Wait for content to be fully rendered
    await new Promise(resolve => setTimeout(resolve, 1000));
    
    const main = document.querySelector('main');
    if (!main) throw new Error('Could not find main content area');

    // Get page title for filename
    const h1 = document.querySelector('main h1');
    const pageTitle = h1?.textContent?.trim() || 'Report';

    // Check if there's a report-content container
    const reportContent = main.querySelector('.report-content');
    
    const sections = [];
    
    // Only add page title to document if there's no report-content container
    if (!reportContent) {
      sections.push(
        new Paragraph({
          children: [new TextRun({ 
            text: pageTitle, 
            font: 'Arial', 
            size: 36, 
            bold: true 
          })],
          spacing: { after: 400 }
        })
      );
    }

    const scrollableElements = main.querySelectorAll('[class*="scroll"], [class*="table"]');
    for (const el of scrollableElements) {
      if (el.scrollHeight > el.clientHeight) {
        el.scrollTop = el.scrollHeight;
        await new Promise(resolve => setTimeout(resolve, 100));
        el.scrollTop = 0;
      }
    }

    let children;
    
    if (reportContent) {
      // Process only the children inside .report-content
      children = Array.from(reportContent.children);
    } else {
      // Process all children as before
      children = Array.from(main.children);
    }
    
    const processedElements = new Set();
    
    for (const child of children) {
      await processElement(child, sections, processedElements, includeCharts, maxTableRows);
    }

    if (sections.length === 0 || (sections.length === 1 && !reportContent)) {
      sections.push(new Paragraph({ 
        children: [new TextRun({ 
          text: 'No content found to export.', 
          font: 'Arial', 
          size: 22 
        })]
      }));
    }

    const validSections = sections.filter(s => s != null);
    if (validSections.length === 0) throw new Error('No valid content to export');

    const doc = new Document({
      sections: [{
        properties: { page: { margin: { top: 1440, right: 1440, bottom: 1440, left: 1440 } } },
        children: validSections
      }]
    });

    const blob = await Packer.toBlob(doc);
    const fileName = `${pageTitle.replace(/[^a-z0-9]/gi, '_').toLowerCase()}_${new Date().toISOString().split('T')[0]}.docx`;
    saveAs(blob, fileName);
    
  } catch (error) {
    console.error('Error exporting to Word:', error);
    throw error;
  }
}

async function processElement(element, sections, processedElements, includeCharts, maxTableRows) {
  const tagName = element.tagName?.toLowerCase();
  
  if (processedElements.has(element)) return;
  if (!element || !tagName || ['script', 'style', 'noscript', 'button'].includes(tagName)) return;
  
  const style = window.getComputedStyle(element);
  if (style.display === 'none' || style.visibility === 'hidden') return;
  
  processedElements.add(element);

  if (tagName === 'h1') {
    const text = element.textContent.trim();
    if (text) sections.push(new Paragraph({ 
      children: [new TextRun({ text, font: 'Arial', size: 32, bold: true })],
      spacing: { before: 400, after: 200 }
    }));
  } else if (tagName === 'h2') {
    const text = element.textContent.trim();
    if (text) sections.push(new Paragraph({ 
      children: [new TextRun({ text, font: 'Arial', size: 26, bold: true })],
      spacing: { before: 300, after: 200 }
    }));
  } else if (tagName === 'h3') {
    const text = element.textContent.trim();
    if (text) sections.push(new Paragraph({ 
      children: [new TextRun({ text, font: 'Arial', size: 24, bold: true })],
      spacing: { before: 200, after: 100 }
    }));
  } else if (tagName === 'h4') {
    const text = element.textContent.trim();
    if (text) sections.push(new Paragraph({ 
      children: [new TextRun({ text, font: 'Arial', size: 22, bold: true })],
      spacing: { before: 200, after: 100 }
    }));
  } else if (tagName === 'p') {
    const text = element.textContent.trim();
    if (text && text.length > 0 && text.length < 5000) {
      // Check if text contains line breaks
      const lines = text.split('\n').filter(line => line.trim());
      
      if (lines.length > 1) {
        // Multiple lines - create separate paragraphs for each
        lines.forEach((line, index) => {
          sections.push(new Paragraph({ 
            children: [new TextRun({ text: line.trim(), font: 'Arial', size: 22 })],
            spacing: { after: index === lines.length - 1 ? 100 : 50 }
          }));
        });
      } else {
        // Single line - create one paragraph
        sections.push(new Paragraph({ 
          children: [new TextRun({ text, font: 'Arial', size: 22 })],
          spacing: { after: 100 }
        }));
      }
    }
  } else if (tagName === 'ul' || tagName === 'ol') {
    const listItems = element.querySelectorAll('li');
    listItems.forEach((li) => {
      const text = li.textContent.trim();
      if (text) {
        sections.push(new Paragraph({
          children: [new TextRun({ text, font: 'Arial', size: 22 })],
          bullet: tagName === 'ul' ? { level: 0 } : undefined,
          numbering: tagName === 'ol' ? { reference: 'default-numbering', level: 0 } : undefined,
          spacing: { after: 50 }
        }));
      }
    });
  } else if (tagName === 'hr') {
    // Add horizontal rule as a bordered paragraph with CSS margins
    const style = window.getComputedStyle(element);
    const marginTop = parseFloat(style.marginTop) || 0;
    const marginBottom = parseFloat(style.marginBottom) || 0;
    
    // Convert pixels to twips (1 pixel ≈ 15 twips)
    const spacingBefore = Math.round(marginTop * 15);
    const spacingAfter = Math.round(marginBottom * 15);
    
    sections.push(new Paragraph({
      children: [new TextRun({ text: '', font: 'Arial', size: 22 })],
      border: {
        bottom: {
          color: 'D1D5DB',
          space: 1,
          style: BorderStyle.SINGLE,
          size: 6
        }
      },
      spacing: { 
        before: spacingBefore > 0 ? spacingBefore : 200, 
        after: spacingAfter > 0 ? spacingAfter : 200 
      }
    }));
  } else if (tagName === 'img') {
    // Add image support
    await captureImage(element, sections);
  } else if (tagName === 'table') {
    const tableData = extractTableData(element, maxTableRows);
    if (tableData?.length > 0) {
      const docxTable = createDocxTable(tableData);
      if (docxTable) {
        sections.push(docxTable);
        sections.push(new Paragraph({ text: '', spacing: { after: 200 } }));
      }
    }
  } else if (tagName === 'div' || tagName === 'section' || tagName === 'article') {
    if (element.classList?.contains('break-after-page') || element.classList?.contains('page-break')) {
      sections.push(new Paragraph({
        children: [new PageBreak()],
        spacing: { after: 0 }
      }));
      return;
    }
    
    if (element.classList?.contains('big-value') || element.querySelector('[class*="big-value"]')) {
      const titleEl = element.querySelector('[class*="title"]');
      const valueEl = element.querySelector('[class*="number"], [class*="value"]');
      
      const title = titleEl?.textContent?.trim() || '';
      const value = valueEl?.textContent?.trim() || '';
      
      if (title && value) {
        sections.push(new Paragraph({
          children: [
            new TextRun({ text: title + ': ', font: 'Arial', size: 22, bold: true }),
            new TextRun({ text: value, font: 'Arial', size: 28, bold: true, color: '2563EB' })
          ],
          spacing: { after: 150 }
        }));
      }
      return;
    }
    
    const directCanvas = Array.from(element.children).find(child => child.tagName === 'CANVAS');
    if (includeCharts && directCanvas) {
      await captureChart(element, sections, processedElements);
      return;
    }
    
    const directTable = Array.from(element.children).find(child => child.tagName === 'TABLE');
    if (directTable && !processedElements.has(directTable)) {
      const tableData = extractTableData(directTable, maxTableRows);
      if (tableData?.length > 0) {
        const docxTable = createDocxTable(tableData);
        if (docxTable) {
          sections.push(docxTable);
          sections.push(new Paragraph({ text: '', spacing: { after: 200 } }));
        }
      }
      processedElements.add(directTable);
      return;
    }
    
    for (const child of Array.from(element.children)) {
      await processElement(child, sections, processedElements, includeCharts, maxTableRows);
    }
  }
}

async function captureChart(chartContainer, sections, processedElements) {
  try {
    const canvas = chartContainer.querySelector('canvas');
    if (!canvas || processedElements.has(canvas)) return;
    
    processedElements.add(canvas);
    processedElements.add(chartContainer);
    
    const titleEl = chartContainer.querySelector('[class*="title"]');
    const chartTitle = titleEl?.textContent?.trim() || '';
    
    if (chartTitle) {
      sections.push(new Paragraph({ 
        children: [new TextRun({ 
          text: chartTitle, 
          font: 'Arial', 
          size: 22, 
          bold: true 
        })],
        spacing: { before: 200, after: 100 }
      }));
    }
    
    const capturedCanvas = await html2canvas(canvas, {
      backgroundColor: '#ffffff',
      scale: 2,
      logging: false,
      useCORS: true
    });
    
    const imageData = capturedCanvas.toDataURL('image/png');
    const base64Data = imageData.split(',')[1];
    
    const maxWidth = 550;
    const aspectRatio = capturedCanvas.height / capturedCanvas.width;
    const width = Math.min(capturedCanvas.width, maxWidth);
    const height = width * aspectRatio;
    
    sections.push(new Paragraph({
      children: [
        new ImageRun({
          data: Uint8Array.from(atob(base64Data), c => c.charCodeAt(0)),
          transformation: { width, height }
        })
      ],
      spacing: { after: 200 }
    }));
  } catch (error) {
    console.warn('Failed to capture chart:', error);
  }
}

async function captureImage(imgElement, sections) {
  try {
    // Use html2canvas to capture the image element (handles CORS better)
    const canvas = await html2canvas(imgElement, {
      backgroundColor: null,
      scale: 2,
      logging: false,
      useCORS: true,
      allowTaint: true
    });
    
    const imageData = canvas.toDataURL('image/png');
    const base64Data = imageData.split(',')[1];
    
    // Get image dimensions
    const naturalWidth = imgElement.naturalWidth || imgElement.width || 400;
    const naturalHeight = imgElement.naturalHeight || imgElement.height || 300;
    
    // Scale to fit page width
    const maxWidth = 550;
    const aspectRatio = naturalHeight / naturalWidth;
    const width = Math.min(naturalWidth, maxWidth);
    const height = width * aspectRatio;
    
    sections.push(new Paragraph({
      children: [
        new ImageRun({
          data: Uint8Array.from(atob(base64Data), c => c.charCodeAt(0)),
          transformation: { width, height }
        })
      ],
      spacing: { before: 100, after: 200 }
    }));
  } catch (error) {
    console.warn('Failed to capture image:', error);
    // Silently skip images that fail to load
  }
}

function extractTableData(tableElement, maxTableRows) {
  const rows = [];
  const allRows = Array.from(tableElement.querySelectorAll('tr'));
  if (allRows.length === 0) return rows;
  
  for (let i = 0; i < Math.min(allRows.length, maxTableRows + 1); i++) {
    const row = allRows[i];
    const cells = Array.from(row.querySelectorAll('td, th'));
    if (cells.length === 0) continue;
    
    const cellData = cells.map(cell => {
      let text = cell.innerText || cell.textContent || '';
      return text.replace(/\s+/g, ' ').trim();
    });
    
    // Check if this is a header row with actual content
    const hasContent = cellData.some(c => c && c.length > 0);
    const isHeaderRow = cells.some(cell => cell.tagName.toLowerCase() === 'th');
    
    // Only include header rows if they have actual text content
    if (isHeaderRow && !hasContent) {
      continue;
    }
    
    if (hasContent) {
      rows.push({
        data: cellData,
        isHeader: isHeaderRow && hasContent
      });
    }
  }
  return rows;
}

function createDocxTable(data) {
  if (!data || data.length === 0) return null;
  
  try {
    const normalizedData = data.map(row => {
      if (!row || !Array.isArray(row.data)) return null;
      return {
        data: row.data.map(cell => String(cell || '').substring(0, 1000)),
        isHeader: row.isHeader || false
      };
    }).filter(row => row != null && row.data.length > 0);
    
    if (normalizedData.length === 0) return null;
    
    const maxCols = Math.max(...normalizedData.map(row => row.data.length));
    const paddedData = normalizedData.map(row => {
      const padded = [...row.data];
      while (padded.length < maxCols) padded.push('');
      return {
        data: padded.slice(0, maxCols),
        isHeader: row.isHeader
      };
    });
    
    // Track data row index for alternating colors (excluding header rows)
    let dataRowIndex = 0;
    
    const rows = paddedData.map((row) => {
      const isHeader = row.isHeader;
      const currentDataRowIndex = dataRowIndex;
      
      // Only increment data row index for non-header rows
      if (!isHeader) {
        dataRowIndex++;
      }
      
      const cells = row.data.map(cellText => {
        return new TableCell({
          children: [new Paragraph({ 
            children: [new TextRun({ 
              text: cellText || '', 
              font: 'Arial',
              size: 18, // 9pt font size for tables
              bold: isHeader,
              color: isHeader ? 'FFFFFF' : '000000'
            })],
            alignment: isHeader ? AlignmentType.CENTER : AlignmentType.LEFT
          })],
          shading: isHeader ? { 
            fill: '304C89'
          } : (currentDataRowIndex % 2 === 0 ? { fill: 'F9FAFB' } : { fill: 'FFFFFF' }),
          margins: {
            top: 80,
            bottom: 80,
            left: 80,
            right: 80
          },
          borders: {
            top: { style: BorderStyle.SINGLE, size: 1, color: 'E5E7EB' },
            bottom: { style: BorderStyle.SINGLE, size: 1, color: 'E5E7EB' },
            left: { style: BorderStyle.SINGLE, size: 1, color: 'E5E7EB' },
            right: { style: BorderStyle.SINGLE, size: 1, color: 'E5E7EB' }
          },
          width: { size: 100 / maxCols, type: WidthType.PERCENTAGE }
        });
      });
      return new TableRow({ 
        children: cells,
        height: { value: 350, rule: 'atLeast' }
      });
    });

    return new Table({
      rows,
      width: { size: 100, type: WidthType.PERCENTAGE }, // Full page width
      layout: 'autofit',
      margins: {
        top: 200,
        bottom: 200
      }
    });
  } catch (error) {
    console.error('Error creating table:', error);
    return null;
  }
}
