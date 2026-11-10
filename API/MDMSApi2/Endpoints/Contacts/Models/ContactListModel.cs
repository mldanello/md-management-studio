namespace MDMSApi2.Endpoints.Contacts.Models;

public class ContactListModel
{
    public int Id { get; set; }
    public string FirstName { get; set; } = string.Empty;
    public string LastName { get; set; } = string.Empty;
    public List<string> SearchTags { get; set; } = new List<string>();
}
