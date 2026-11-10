using System.Collections.Generic;

namespace MDMSApi2.Repositories;

public record ContactName(string FirstName, string LastName);

public interface IContactRepository
{
    // Return FirstName and LastName for contacts matching the filter
    IEnumerable<ContactName> List(string filter);
}
