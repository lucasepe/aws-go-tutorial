package main

import (
	"context"
	"fmt"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

// The entry point that runs your Lambda function code.
func main() {
	lambda.Start(handler)
}

// handler is your Lambda handler signature and includes the code which will be executed.
//
// See https://docs.aws.amazon.com/lambda/latest/dg/golang-handler.html for valid handler signatures.
// See https://github.com/aws/aws-lambda-go for event details.
func handler(ctx context.Context, evt events.DynamoDBEvent) {
	for _, rec := range evt.Records {
		fmt.Printf("Processing request data for event ID %s, type %s.\n", rec.EventID, rec.EventName)

		// Print new values for attributes of type String
		for k, v := range rec.Change.NewImage {
			if v.DataType() == events.DataTypeString {
				fmt.Printf("Attribute name: %s, value: %s\n", k, v.String())
			}
		}
	}
}
