using MDMSApi2.Domain;
using MDMSApi2.Endpoints.Contacts.Models;

namespace MDMSApi2.Endpoints.Contacts;

internal static class ContactMappers
{
    public static ContactListModel ToListModel(this Contact c)
    {
        return new ContactListModel
        {
            Id = c.Id,
            FirstName = c.FirstName,
            LastName = c.LastName,
            SearchTags = c.ContactSearchTags?
                .Where(t => t.IsActive)
                .Select(t => t.TagText ?? string.Empty)
                .OrderBy(t => t)
                .ToList() ?? new List<string>()
        };
    }

    public static ContactDetailModel ToDetailModel(this Contact c)
    {
        return new ContactDetailModel
        {
            Id = c.Id,
            TenantId = c.TenantId,
            FirstName = c.FirstName,
            MiddleName = c.MiddleName,
            LastName = c.LastName,
            CompanyName = c.CompanyName,
            Email = c.Email,
            Web = c.Web,
            Notes = c.Notes,
            IsActive = c.IsActive,
            CreatedAt = c.CreatedAt,
            ModifiedAt = c.ModifiedAt,
            ContactAddresses = c.ContactAddresses?.Select(a => a.ToModel()).ToList() ?? new List<ContactAddressModel>(),
            ContactPhones = c.ContactPhones?.Select(p => p.ToModel()).ToList() ?? new List<ContactPhoneModel>(),
            ContactSearchTags = c.ContactSearchTags?
                .OrderBy(t => t.TagText ?? string.Empty)
                .Select(t => t.ToModel())
                .ToList() ?? new List<ContactSearchTagModel>()
        };
    }

    public static ContactAddressModel ToModel(this ContactAddress a)
    {
        return new ContactAddressModel
        {
            Id = a.Id,
            ContactId = a.ContactId,
            Street1 = a.Street1,
            Street2 = a.Street2,
            City = a.City,
            County = a.County,
            State = a.State,
            Zip = a.Zip,
            IsActive = a.IsActive,
            CreatedAt = a.CreatedAt,
            ModifiedAt = a.ModifiedAt
        };
    }

    public static ContactPhoneModel ToModel(this ContactPhone p)
    {
        return new ContactPhoneModel
        {
            Id = p.Id,
            ContactId = p.ContactId,
            Number = p.Number,
            Type = p.Type,
            IsPrimary = p.IsPrimary,
            IsActive = p.IsActive,
            CreatedAt = p.CreatedAt,
            ModifiedAt = p.ModifiedAt
        };
    }

    public static ContactSearchTagModel ToModel(this ContactSearchTag t)
    {
        return new ContactSearchTagModel
        {
            Id = t.Id,
            ContactId = t.ContactId,
            TagText = t.TagText,
            IsActive = t.IsActive,
            CreatedAt = t.CreatedAt,
            ModifiedAt = t.ModifiedAt
        };
    }

    public static Contact CreateFromModel(ContactDetailModel m)
    {
        var now = DateTime.UtcNow;
        var contact = new Contact
        {
            TenantId = m.TenantId,
            FirstName = m.FirstName,
            MiddleName = m.MiddleName,
            LastName = m.LastName,
            CompanyName = m.CompanyName,
            Email = m.Email,
            Web = m.Web,
            Notes = m.Notes,
            IsActive = m.IsActive,
            CreatedAt = m.CreatedAt == default ? now : m.CreatedAt,
            ModifiedAt = m.ModifiedAt == default ? now : m.ModifiedAt
        };

        if (m.ContactAddresses is not null)
        {
            foreach (var a in m.ContactAddresses)
            {
                contact.ContactAddresses.Add(CreateAddressFromModel(a));
            }
        }

        if (m.ContactPhones is not null)
        {
            foreach (var p in m.ContactPhones)
            {
                contact.ContactPhones.Add(CreatePhoneFromModel(p));
            }
        }

        if (m.ContactSearchTags is not null)
        {
            foreach (var t in m.ContactSearchTags)
            {
                contact.ContactSearchTags.Add(CreateTagFromModel(t));
            }
        }

        return contact;
    }

    public static ContactAddress CreateAddressFromModel(ContactAddressModel m)
    {
        var now = m.CreatedAt == default ? DateTime.UtcNow : m.CreatedAt;
        return new ContactAddress
        {
            Street1 = m.Street1,
            Street2 = m.Street2,
            City = m.City,
            County = m.County,
            State = m.State,
            Zip = m.Zip,
            IsActive = m.IsActive,
            CreatedAt = now,
            ModifiedAt = m.ModifiedAt == default ? now : m.ModifiedAt
        };
    }

    public static ContactPhone CreatePhoneFromModel(ContactPhoneModel m)
    {
        var now = m.CreatedAt == default ? DateTime.UtcNow : m.CreatedAt;
        return new ContactPhone
        {
            Number = m.Number,
            Type = m.Type,
            IsPrimary = m.IsPrimary,
            IsActive = m.IsActive,
            CreatedAt = now,
            ModifiedAt = m.ModifiedAt == default ? now : m.ModifiedAt
        };
    }

    public static ContactSearchTag CreateTagFromModel(ContactSearchTagModel m)
    {
        var now = m.CreatedAt == default ? DateTime.UtcNow : m.CreatedAt;
        return new ContactSearchTag
        {
            TagText = m.TagText,
            IsActive = m.IsActive,
            CreatedAt = now,
            ModifiedAt = m.ModifiedAt == default ? now : m.ModifiedAt
        };
    }

    public static void UpdateFromModel(this Contact existing, ContactDetailModel m)
    {
        var now = DateTime.UtcNow;
        existing.TenantId = m.TenantId;
        existing.FirstName = m.FirstName;
        existing.MiddleName = m.MiddleName;
        existing.LastName = m.LastName;
        existing.CompanyName = m.CompanyName;
        existing.Email = m.Email;
        existing.Web = m.Web;
        existing.Notes = m.Notes;
        existing.IsActive = m.IsActive;
        existing.ModifiedAt = now;

        // Replace child collections
        existing.ContactAddresses.Clear();
        if (m.ContactAddresses is not null)
        {
            foreach (var a in m.ContactAddresses)
            {
                existing.ContactAddresses.Add(CreateAddressFromModel(a));
            }
        }

        existing.ContactPhones.Clear();
        if (m.ContactPhones is not null)
        {
            foreach (var p in m.ContactPhones)
            {
                existing.ContactPhones.Add(CreatePhoneFromModel(p));
            }
        }

        existing.ContactSearchTags.Clear();
        if (m.ContactSearchTags is not null)
        {
            foreach (var t in m.ContactSearchTags)
            {
                existing.ContactSearchTags.Add(CreateTagFromModel(t));
            }
        }
    }
}
