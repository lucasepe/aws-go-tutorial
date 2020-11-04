package main

import (
	"context"
	"encoding/base64"
	"log"
	"net/http"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/lucasepe/aws-go-tutorial/avatar/identicon"
)

// The entry point that runs your Lambda function code.
func main() {
	lambda.Start(handler)
}

// handler is your Lambda handler signature and includes the code which will be executed.
//
// See https://docs.aws.amazon.com/lambda/latest/dg/golang-handler.html for valid handler signatures.
// See https://github.com/aws/aws-lambda-go for event details.
func handler(ctx context.Context, evt events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	log.Printf("Processing request data for request %s.\n", evt.RequestContext.RequestID)

	username := evt.PathParameters["username"]
	if len(username) == 0 {
		code := http.StatusBadRequest
		msg := http.StatusText(code)
		return events.APIGatewayProxyResponse{Body: msg, StatusCode: code}, nil
	}

	key := []byte{0x00, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88, 0x99, 0xAA, 0xBB, 0xCC, 0xDD, 0xEE, 0xFF}
	icon := identicon.New7x7(key)

	log.Printf("creating identicon for '%s'\n", username)

	pngdata := icon.Render([]byte(username))

	body := base64.StdEncoding.EncodeToString(pngdata)

	return events.APIGatewayProxyResponse{
		Body: body,
		Headers: map[string]string{
			"Content-Type": "image/png",
		},
		IsBase64Encoded: true,
		StatusCode:      200,
	}, nil
}
