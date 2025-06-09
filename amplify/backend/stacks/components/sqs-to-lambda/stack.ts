import { Construct } from 'constructs';
import { StackProps } from 'aws-cdk-lib';
import { IFunction } from 'aws-cdk-lib/aws-lambda';
import { SqsEventSource } from 'aws-cdk-lib/aws-lambda-event-sources';
import { Queue, IQueue } from 'aws-cdk-lib/aws-sqs';

interface SqsToLambdaProps extends StackProps {
  lambda: IFunction;
}

export function createQueueAndAddEventSource(
  scope: Construct,
  id: string,
  props: SqsToLambdaProps
): {
  queue: IQueue;
} {
  const deadLetterQueue = new Queue(scope, `${id}DLQ`, {
    queueName: `${id}-dlq`
  });

  const queue = new Queue(scope, `${id}Queue`, {
    queueName: `${id}-queue`,
    deadLetterQueue: {
      maxReceiveCount: 3,
      queue: deadLetterQueue
    }
  });

  queue.grantConsumeMessages(props.lambda);

  props.lambda.addEventSource(new SqsEventSource(queue, {
    batchSize: 5,
    maxBatchingWindow: undefined,
    enabled: true,
  }));

  return {
    queue,
  };
}