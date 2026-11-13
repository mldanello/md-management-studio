using Microsoft.AspNetCore.Mvc;
using MDMSApi2.Domain;
using Microsoft.EntityFrameworkCore;
using MDMSApi2.Models;
using MDMSApi2.Endpoints.Contacts.Models;

namespace MDMSApi2.Endpoints.Contacts;

public static class ContactHandlers
{
    public static async Task<IResult> GetContactsAsync(ApplicationDbContext db, ILogger<Program> log)
    {
        log.LogInformation("Fetching contact list");
        var contacts = await db.Contacts
            .Include(c => c.ContactSearchTags)
            .ToListAsync();
        var items = contacts.Select(c => c.ToListModel()).ToList();
        return Results.Ok(items);
    }

    public static async Task<IResult> GetContactsFilteredAsync(ApplicationDbContext db, ILogger<Program> log, string? filter = null)
    {
        log.LogInformation("Fetching filtered contacts with filter={Filter}", filter);

        var query = db.Contacts
            .Include(c => c.ContactSearchTags)
            .AsQueryable();

        if (!string.IsNullOrWhiteSpace(filter))
        {
            query = query.Where(c =>
                (c.FirstName != null && c.FirstName.Contains(filter)) ||
                (c.LastName != null && c.LastName.Contains(filter)) ||
                c.ContactSearchTags.Any(t => t.TagText != null && t.TagText.Contains(filter)));
        }

        var contacts = await query.ToListAsync();
        var items = contacts.Select(c => c.ToListModel()).ToList();

        log.LogInformation("Found {Count} contacts", items.Count);
        return Results.Ok(items);
    }

    public static async Task<IResult> GetContactByIdAsync(int id, ApplicationDbContext db, ILogger<Program> log)
    {
        log.LogInformation("Fetching contact by id={Id}", id);
        var entity = await db.Contacts
            .Where(c => c.Id == id)
            .Include(c => c.ContactAddresses)
            .Include(c => c.ContactPhones)
            .Include(c => c.ContactSearchTags)
            .SingleOrDefaultAsync();

        if (entity is null)
        {
            log.LogWarning("Contact not found id={Id}", id);
            return Results.NotFound();
        }

        var item = entity.ToDetailModel();
        return Results.Ok(item);
    }

    public static async Task<IResult> CreateContactAsync(ContactDetailModel model, ApplicationDbContext db, ILogger<Program> log)
    {
        log.LogInformation("Creating contact FirstName={FirstName} LastName={LastName}", model.FirstName, model.LastName);
        var contact = ContactMappers.CreateFromModel(model);
        db.Contacts.Add(contact);
        await db.SaveChangesAsync();
        log.LogInformation("Created contact id={Id}", contact.Id);
        return Results.Created($"/contacts/{contact.Id}", contact.ToDetailModel());
    }

    public static async Task<IResult> UpdateContactAsync(int id, ContactDetailModel model, ApplicationDbContext db, ILogger<Program> log)
    {
        log.LogInformation("Updating contact id={Id}", id);
        var existing = await db.Contacts
            .Include(c => c.ContactAddresses)
            .Include(c => c.ContactPhones)
            .Include(c => c.ContactSearchTags)
            .SingleOrDefaultAsync(c => c.Id == id);

        if (existing is null)
        {
            log.LogWarning("Contact not found id={Id}", id);
            return Results.NotFound();
        }

        existing.UpdateFromModel(model);
        await db.SaveChangesAsync();
        log.LogInformation("Updated contact id={Id}", id);
        return Results.NoContent();
    }

    public static async Task<IResult> DeleteContactAsync(int id, ApplicationDbContext db, ILogger<Program> log)
    {
        log.LogInformation("Deleting contact id={Id}", id);
        var existing = await db.Contacts
            .Where(c => c.Id == id)
            .Include(c => c.ContactAddresses)
            .Include(c => c.ContactPhones)
            .Include(c => c.ContactSearchTags)
            .SingleOrDefaultAsync();

        if (existing is null) return Results.NotFound();

        // Remove child entities explicitly to ensure cleanup regardless of cascade rules
        if (existing.ContactAddresses?.Any() == true)
        {
            db.ContactAddresses.RemoveRange(existing.ContactAddresses);
        }

        if (existing.ContactPhones?.Any() == true)
        {
            db.ContactPhones.RemoveRange(existing.ContactPhones);
        }

        if (existing.ContactSearchTags?.Any() == true)
        {
            db.ContactSearchTags.RemoveRange(existing.ContactSearchTags);
        }

        db.Contacts.Remove(existing);
        await db.SaveChangesAsync();
        return Results.NoContent();
    }
}
