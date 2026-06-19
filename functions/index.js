const { onCall } = require("firebase-functions/v2/https");
const { initializeApp } = require("firebase-admin/app");
const { VertexAI } = require("@google-cloud/vertexai");

initializeApp();

// This function handles the Gemini API call to extract receipt data
exports.extractWarrantyData = onCall({
  // Enforce App Check to prevent unauthorized calls
  enforceAppCheck: true,
  memory: "512MiB",
}, async (request) => {
  try {
    const { base64Image, mimeType } = request.data;

    if (!base64Image) {
      throw new Error("No image data provided");
    }

    const vertexAI = new VertexAI({
      project: process.env.GCLOUD_PROJECT,
      location: "us-central1",
    });

    const model = vertexAI.getGenerativeModel({
      model: "gemini-1.5-flash",
    });

    const prompt = `
      Analyze this receipt/invoice image.
      Extract the following information:
      1. Product Name (be specific, e.g., "Logitech G502 Mouse")
      2. Date of Purchase (format as YYYY-MM-DD)
      3. Warranty Duration in months (estimate if not explicitly stated, e.g., 12 for most electronics)

      Return ONLY a valid JSON object with this structure:
      {
        "productName": "string",
        "purchaseDate": "YYYY-MM-DD",
        "warrantyDurationMonths": number
      }
      Do not include any markdown formatting, backticks, or extra text.
    `;

    const imagePart = {
      inlineData: {
        data: base64Image,
        mimeType: mimeType || "image/jpeg",
      },
    };

    const result = await model.generateContent([prompt, imagePart]);
    const responseText = result.response.candidates[0].content.parts[0].text;

    // Clean up the response in case the model included markdown blocks
    const cleanedJson = responseText.replace(/```json|```/g, "").trim();

    return JSON.parse(cleanedJson);
  } catch (error) {
    console.error("Gemini Extraction Error:", error);
    throw new Error("Failed to process receipt: " + error.message);
  }
});
