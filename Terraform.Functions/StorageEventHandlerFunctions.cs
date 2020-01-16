// Default URL for triggering event grid function in the local environment.
// http://localhost:7071/runtime/webhooks/EventGrid?functionName={functionname}
using System;
using Microsoft.Azure.EventGrid.Models;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.EventGrid;
using Microsoft.Extensions.Logging;

namespace Terraform.Functions
{
    public static class StorageEventHandlerFunctions
    {
        [FunctionName(nameof(StorageEventHandler))]
        public static void StorageEventHandler([EventGridTrigger]EventGridEvent eventGridEvent, ILogger log, [EventGrid(TopicEndpointUri = @"EGNotificationTopic", TopicKeySetting = @"EGNotificationTopicKey")]out EventGridEvent notificationMessage)
        {
            log.LogTrace(@"GOT STORAGE EVENT");
            log.LogInformation(eventGridEvent.Data.ToString());

            notificationMessage = new EventGridEvent
            {
                Data = $@"Blob event received: {eventGridEvent.Subject} - {eventGridEvent.Data}",
                DataVersion = @"1",
                EventType = @"BlobReceived",
                Subject = "/custom/blobreceived",
                EventTime = DateTime.UtcNow,
                Id = Guid.NewGuid().ToString()
            };

            log.LogTrace(@"SENT STORAGE EVENT");
        }
    }
}
