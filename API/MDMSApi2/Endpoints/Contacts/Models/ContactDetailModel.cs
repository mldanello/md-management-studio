using System;
using System.Collections.Generic;

namespace MDMSApi2.Endpoints.Contacts.Models;

public class ContactDetailModel
{
    public int Id { get; set; }
    public int TenantId { get; set; }
    public string FirstName { get; set; } = string.Empty;
    public string? MiddleName { get; set; }
    public string LastName { get; set; } = string.Empty;
    public string? CompanyName { get; set; }
    public string? Email { get; set; }
    public string? Web { get; set; }
    public string? Notes { get; set; }
    public bool IsActive { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime ModifiedAt { get; set; }

    public List<ContactAddressModel> ContactAddresses { get; set; } = new();
    public List<ContactPhoneModel> ContactPhones { get; set; } = new();
    public List<ContactSearchTagModel> ContactSearchTags { get; set; } = new();
}
