using Microsoft.EntityFrameworkCore;

namespace MDMSApi2.Domain;

public partial class ApplicationDbContext : DbContext
{
    public ApplicationDbContext()
    {
    }

    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Contact> Contacts { get; set; }

    public virtual DbSet<ContactAddress> ContactAddresses { get; set; }

    public virtual DbSet<ContactPhone> ContactPhones { get; set; }

    public virtual DbSet<ContactSearchTag> ContactSearchTags { get; set; }

    public virtual DbSet<Tenant> Tenants { get; set; }
    public virtual DbSet<User> Users { get; set; }
}
