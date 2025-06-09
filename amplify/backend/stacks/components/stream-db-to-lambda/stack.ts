import { Construct } from 'constructs';
import { StackProps } from 'aws-cdk-lib';
import { IFunction, StartingPosition } from 'aws-cdk-lib/aws-lambda';
import { DynamoEventSource } from 'aws-cdk-lib/aws-lambda-event-sources';
import { ITable } from 'aws-cdk-lib/aws-dynamodb';

interface StreamDbToLambdaProps extends StackProps {
  lambda: IFunction;
  sourceTables: ITable[];
}

export function createStreamDbToLambda(
  scope: Construct,
  id: string,
  props: StreamDbToLambdaProps
): {
  streamArns: (string | undefined)[];
} {
  props.sourceTables.forEach(table => {
    table.grantStreamRead(props.lambda);
    props.lambda.addEventSource(new DynamoEventSource(table, {
      startingPosition: StartingPosition.LATEST,
      batchSize: 5,
      retryAttempts: 2,
    }));
  });

  return {
    streamArns: props.sourceTables.map(table => table.tableStreamArn),
  };
}