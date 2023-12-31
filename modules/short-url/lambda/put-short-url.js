const { CloudFrontKeyValueStoreClient, PutKeyCommand, DescribeKeyValueStoreCommand } = require("@aws-sdk/client-cloudfront-keyvaluestore");
const { SignatureV4MultiRegion } = require("@aws-sdk/signature-v4-multi-region");
require("@aws-sdk/signature-v4-crt");

const KvsARN = process.env.KVS_ARN;
const client = new CloudFrontKeyValueStoreClient({
    region: process.env.AWS_REGION,
    signerConstructor: SignatureV4MultiRegion
   });

exports.handler = async (event, context) => {
    console.log("Received event:", event);
    console.log("Received context:", context);
    const method = event.requestContext.http.method;
    if (method !== "POST") {
        return {
            statusCode: 405,
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ message: "Method not allowed" })
        };
    }
    
    try {
        const requestBody = JSON.parse(event.body);

        const originUrl = requestBody.originUrl;
        const Key = generateRandomString(6);

        const input = {
            Key,
            Value: originUrl,
            KvsARN,
            IfMatch: await retrieveEtag()
        };

        const command = new PutKeyCommand(input);
        await client.send(command);

        return {
            statusCode: 200,
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ Key })
        };
    } catch (error) {
        console.error("Error occurred:", error);

        return {
            statusCode: 500,
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ message: "Internal server error" })
        };
    }
};

async function retrieveEtag() {
    const input = {
        KvsARN
      };
      const command = new DescribeKeyValueStoreCommand(input);
      const response = await client.send(command);

      return response.ETag;
}

function generateRandomString(length) {
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    let result = '';
    const charactersLength = characters.length;
    for (let i = 0; i < length; i++) {
        result += characters.charAt(Math.floor(Math.random() * charactersLength));
    }
    return result;
}