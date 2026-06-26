class AiPrompts {
  static const String receiptWarrantyExtraction = '''
    Analyze this receipt/invoice/document. 
    First, determine if this is a receipt or a warranty document. 
    Receipts usually have merchant names, dates, itemized lists, and totals. 
    Warranties usually have "Limited Warranty", serial numbers, or coverage terms.
    If it is a personal photo, landscape, or unrelated document, set "isReceiptOrWarranty" to false.

    Extract the following information:
    1. Product Name (be specific, e.g., "Logitech G502 Mouse")
    2. Date of Purchase (format as YYYY-MM-DD)
    3. Warranty Duration in months: 
       - ONLY extract this if it is EXPLICITLY mentioned in the receipt.
       - If it is not mentioned, return null for this field. 
       - DO NOT guess or estimate.

    Return ONLY a valid JSON object with this structure:
    {
      "isReceiptOrWarranty": boolean,
      "productName": "string",
      "purchaseDate": "YYYY-MM-DD",
      "warrantyDurationMonths": number or null
    }
    Do not include any markdown formatting, backticks, or extra text.
  ''';
}
