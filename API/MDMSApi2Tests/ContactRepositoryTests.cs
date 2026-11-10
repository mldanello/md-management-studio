using System;
using System.Linq;
using Xunit;
using Microsoft.EntityFrameworkCore;
using MDMSApi2.Domain;
using MDMSApi2.Repositories;

public class ContactRepositoryTests
{
    [Fact]
    public void List_ReturnsSeededContact()
    {
        var options = new DbContextOptionsBuilder<ApplicationDbContext>()
            .UseInMemoryDatabase(databaseName: "TestDb_" + Guid.NewGuid())
            .Options;

        int? seededId = null;

        // Seed a sample contact
        using (var seedContext = new ApplicationDbContext(options))
        {
            var c = new Contact
            {
                // set required Contact properties; adjust names as needed
                FirstName = "Test",
                LastName = "User",
                /*
                 * The EF Core In-Memory provider does not automatically generate or update values for 
                 * RowVersion / Timestamp columns because it is not a true relational database.
                 */
                RowVersion = Guid.NewGuid().ToByteArray()       // provide a value for the RowVersion property to avoid validation errors; adjust as needed
            };
            seedContext.Contacts.Add(c);
            seedContext.SaveChanges();
            // capture key if available
            seededId = (int?)(c.Id); // change cast/property as appropriate
        }

        try
        {
            // Run the repository method under test
            using (var testContext = new ApplicationDbContext(options))
            {
                var repo = new ContactRepository(testContext);
                var results = repo.List(string.Empty).ToList();
                Assert.True(results.Count > 0, "Expected at least one contact from List()");
            }
        }
        finally
        {
            // Remove seeded sample row
            using (var cleanupContext = new ApplicationDbContext(options))
            {
                if (seededId.HasValue)
                {
                    var toRemove = cleanupContext.Contacts.FirstOrDefault(x => x.Id == seededId.Value);
                    if (toRemove != null)
                    {
                        cleanupContext.Contacts.Remove(toRemove);
                        cleanupContext.SaveChanges();
                    }
                }
            }
        }
    }
}