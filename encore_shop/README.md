# encore_shop

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Customized business logic in Amplify gen2

https://docs.amplify.aws/flutter/build-a-backend/data/custom-business-logic/

## The definitive article on counters with AWS DynamoDb

https://aws.amazon.com/blogs/database/implement-resource-counters-with-amazon-dynamodb/

We implement the Atomic counter pattern in Amplifyy Gen 2 .
Overapplication of the Xerian counter is fine as we need the number to be unique but not the counter to be accurate.
Therefore we allow Amplify to retry, which can lead to overapplication if collisions occur.
This means the occurance of a failure requiring the user to retry is vanishingly small.

Some other resources referenced when implementing the counter

https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Expressions.UpdateExpressions.html#Expressions.UpdateExpressions.SET.IncrementAndDecrement

https://docs.aws.amazon.com/appsync/latest/devguide/built-in-modules-js.html
