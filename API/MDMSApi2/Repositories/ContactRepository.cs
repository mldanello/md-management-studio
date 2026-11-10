using System.Collections.Generic;
using System.Linq;
using MDMSApi2.Domain;
using Microsoft.EntityFrameworkCore;

namespace MDMSApi2.Repositories;

public class ContactRepository : IContactRepository
{
    private readonly ApplicationDbContext _db;

    public ContactRepository(ApplicationDbContext db)
    {
        _db = db;
    }

    public IEnumerable<ContactName> List(string filter)
    {
        if (string.IsNullOrWhiteSpace(filter))
        {
            return _db.Contacts
                .Select(c => new ContactName(c.FirstName ?? string.Empty, c.LastName ?? string.Empty))
                .ToList();
        }

        var f = filter.Trim();

        return _db.Contacts
            .Where(c => EF.Functions.Like(c.FirstName, $"%{f}%") || EF.Functions.Like(c.LastName, $"%{f}%"))
            .Select(c => new ContactName(c.FirstName ?? string.Empty, c.LastName ?? string.Empty))
            .ToList();
    }
}
