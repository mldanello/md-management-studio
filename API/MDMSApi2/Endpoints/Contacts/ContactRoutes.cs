using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Routing;

namespace MDMSApi2.Endpoints.Contacts;

public static class ContactRoutes
{
    public static void MapContactRoutes(this IEndpointRouteBuilder routes)
    {
        var group = routes.MapGroup("/contacts").RequireAuthorization();

        group.MapGet("/", ContactHandlers.GetContactsFilteredAsync).WithName("GetContacts");
        group.MapGet("/{id}", ContactHandlers.GetContactByIdAsync).WithName("GetContactById");
        group.MapPost("/", ContactHandlers.CreateContactAsync).WithName("CreateContact");
        group.MapPut("/{id}", ContactHandlers.UpdateContactAsync).WithName("UpdateContact");
        group.MapDelete("/{id}", ContactHandlers.DeleteContactAsync).WithName("DeleteContact");
    }
}
