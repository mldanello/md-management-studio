using System;

namespace MDMSApi2.Endpoints.Contacts.Models;

public class ContactPhoneModel
{
    public int Id { get; set; }
    public int ContactId { get; set; }
    public string Number { get; set; } = string.Empty;
    public string? Type { get; set; }
    public bool IsPrimary { get; set; }
    public bool IsActive { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime ModifiedAt { get; set; }
}
