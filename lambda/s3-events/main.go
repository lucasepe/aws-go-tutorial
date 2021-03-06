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
func handler(ctx context.Context, evt events.S3Event) {
	for _, rec := range evt.Records {
		el := rec.S3

		fmt.Printf("[%s - %s @ %s] Bucket = %s, Key = %s\n",
			rec.EventSource, rec.EventName, rec.EventTime, el.Bucket.Name, el.Object.Key)
	}
}
