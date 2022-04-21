const aws = require('aws-sdk');

exports.handler = async (event, context) => {
    const body = JSON.parse(event.body);
    return {
        statusCode: 200,
        headers: {
            'Content-Type': 'application/json'
        },
        body,
    }
};