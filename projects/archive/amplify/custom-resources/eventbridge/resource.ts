
import { Stack, aws_events } from 'aws-cdk-lib';
import { IEventBus } from 'aws-cdk-lib/aws-events';
import { LogGroup } from 'aws-cdk-lib/aws-logs';
import { CloudWatchLogGroup } from 'aws-cdk-lib/aws-events-targets';
import { Function } from 'aws-cdk-lib/aws-lambda';
import { EventbridgeToLambda, EventbridgeToLambdaProps } from '@aws-solutions-constructs/aws-eventbridge-lambda';

export function configureEventBridge(
    stack: Stack,
    busName: string,
): IEventBus {
    // Reference or create an EventBridge EventBus
    const eventBus = aws_events.EventBus.fromEventBusName(
        stack,
        busName,
        "default"
    );

    // Configure log group for infinite retention
    const logGroup = new LogGroup(stack, 'EventLogGroup', {
        logGroupName: "/aws/events/eventbridge-logs",
        retention: Infinity,
    });

    const rule = new aws_events.Rule(stack, 'event-log-group-rule', {
        eventPattern: {
            account: aws_events.Match.exactString(stack.account),
        },
    });

    rule.addTarget(new CloudWatchLogGroup(logGroup))

    return eventBus
}


export function eventbridgeToLambda(
    stack: Stack,
    eventBus: IEventBus,
    lambda: Function,
    source: string,
): EventbridgeToLambda {

    eventBus.grantPutEventsTo(lambda)

    const constructProps: EventbridgeToLambdaProps = {
        existingLambdaObj: lambda,
        eventRuleProps: {
            eventBus: eventBus,
            eventPattern: {
                source: [source]
            }
        },
    };

    return new EventbridgeToLambda(stack, source.replaceAll('.', '-'), constructProps);
}