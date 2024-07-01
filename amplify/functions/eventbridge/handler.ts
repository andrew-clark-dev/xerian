import { Handler } from 'aws-lambda';
import AWS from 'aws-sdk';
const eventBridgeClient = new AWS.EventBridge();


export const handler: Handler = async (event, context) => {
    try {
        console.log('Request:', JSON.stringify(event, undefined, 2));

        let requestBody = event['payload'];
        if (!requestBody) {
            requestBody = '';
        }

        // Structure of EventBridge Event
        const eventbridgeEvent = {
            'Time': new Date(),
            'Source': event['source'],
            'Detail': requestBody,
            'DetailType': event['detailType']
        }

        console.log("EventBridge event: ", eventbridgeEvent);

        // Send event to EventBridge
        const response = await eventBridgeClient.putEvents({
            Entries: [
                eventbridgeEvent
            ]
        }).promise();

        console.log('EventBridge response:', response);
    } catch (error) {
        console.error("There was a problem: ", error);
        return {
            statusCode: 500,
            headers: { "Content-Type": "text/plain" },
            body: `There was a problem: ${error}`
        };
    }

    return {
        statusCode: 200,
        headers: { "Content-Type": "text/plain" },
        body: `from Producer...`
    };

};