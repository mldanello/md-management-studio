using System;

namespace MDMSApi2.Endpoints.Contacts.Models;

public class ContactAddressModel
{
    public int Id { get; set; }
    public int ContactId { get; set; }
    public string? Street1 { get; set; }
    public string? Street2 { get; set; }
    public string? City { get; set; }
    public string? County { get; set; }
    public string? State { get; set; }
    public string? Zip { get; set; }
    public bool IsActive { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime ModifiedAt { get; set; }
}
