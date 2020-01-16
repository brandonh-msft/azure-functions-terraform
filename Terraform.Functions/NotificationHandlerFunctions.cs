// Default URL for triggering event grid function in the local environment.
// http://localhost:7071/runtime/webhooks/EventGrid?functionName={functionname}
using Microsoft.Azure.EventGrid.Models;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.EventGrid;
using Microsoft.Extensions.Logging;

namespace Terraform.Functions
{
    public static class NotificationHandlerFunctions
    {
        [FunctionName(nameof(NotificationHandler))]
        public static void NotificationHandler([EventGridTrigger]EventGridEvent eventGridEvent, ILogger log)
        {
            log.LogTrace(@"GOT IT");
            log.LogInformation($@"Received notification! {eventGridEvent.Data}");
        }
    }
}
