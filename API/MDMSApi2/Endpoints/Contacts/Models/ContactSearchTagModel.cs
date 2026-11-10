using System;

namespace MDMSApi2.Endpoints.Contacts.Models;

public class ContactSearchTagModel
{
    public int Id { get; set; }
    public int ContactId { get; set; }
    public string? TagText { get; set; }
    public bool IsActive { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime ModifiedAt { get; set; }
}
