import { Construct } from 'constructs';
import { StackProps } from 'aws-cdk-lib';
import { IFunction, StartingPosition } from 'aws-cdk-lib/aws-lambda';
import { DynamoEventSource } from 'aws-cdk-lib/aws-lambda-event-sources';
import { ITable } from 'aws-cdk-lib/aws-dynamodb';
export function streamDbToLambdaStack(
  scope: Construct,
  id: string,
  props: StackProps & {
    lambda: IFunction;
    sourceTables: ITable[];
    targetTable: ITable;
  }
): {
  tableName: string;
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

  props.targetTable.grantWriteData(props.lambda);

  return {
    tableName: props.targetTable.tableName,
    streamArns: props.sourceTables.map(table => table.tableStreamArn),
  };
}