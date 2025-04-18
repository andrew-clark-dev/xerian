import { Duration } from 'aws-cdk-lib';
import { Construct } from 'constructs';
import { Queue } from 'aws-cdk-lib/aws-sqs';
import { ITable } from 'aws-cdk-lib/aws-dynamodb';
import { IFunction } from 'aws-cdk-lib/aws-lambda';


export interface SQSQueueProps {
  queueName: string;
}

export function createQueue(scope: Construct, props: SQSQueueProps) {
  const componentName = capitalize(props.queueName);

  // 👇 Dead Letter Queue
  const dlq = new Queue(scope, `${componentName}DLQ`, {
    queueName: `${props.queueName}-dlq`,
    retentionPeriod: Duration.days(14), // Retain messages for 14 days (max)
  });

  // 👇 Main SQS Queue with DLQ
  const queue = new Queue(scope, `${componentName}Queue`, {
    queueName: `${props.queueName}-queue`,
    visibilityTimeout: Duration.seconds(30), // same as the lambda timeout
    deadLetterQueue: {
      maxReceiveCount: 3,
      queue: dlq,
    },
  });

  return { queue, dlq };
}

function capitalize(str: string): string {
  return str.charAt(0).toUpperCase() + str.slice(1);
}


type FunctionWithEnvironment = {
  addEnvironment(key: string, value: string): void;
  resources: {
    lambda: IFunction;
  }
};

interface AccessProps {
  tables: ITable[];
  functions: FunctionWithEnvironment[];
}

export function giveFullTableAccess(scope: Construct, props: AccessProps) {
  props.tables.forEach((table) => {
    const envVar = `${(table.tableName.split('-')[0]).toUpperCase()}_TABLE`;
    props.functions.forEach((fn) => {
      fn.addEnvironment(envVar, table.tableName);
      table.grantFullAccess(fn.resources.lambda);
    });
  });
}

