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
func handler(ctx context.Context, evt events.SQSEvent) {
	for _, rec := range evt.Records {
		fmt.Printf("Event Source : %s\n", rec.EventSource)
		fmt.Printf("Message ID   : %s\n", rec.MessageId)
		fmt.Printf("Message Body : %s\n", rec.Body)
		fmt.Printf("Attributes   : %v\n", rec.Attributes)
	}
}
