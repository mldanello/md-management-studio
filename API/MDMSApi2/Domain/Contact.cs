using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MDMSApi2.Domain;

[Table("Contact")]
public partial class Contact : IEntityBase
{
    [Key]
    public int Id { get; set; }

    [Column("TenantID")]
    public int TenantId { get; set; }

    [MaxLength(100)]
    public string FirstName { get; set; } = null!;

    [MaxLength(100)]
    public string? MiddleName { get; set; }

    [MaxLength(100)]
    public string LastName { get; set; } = null!;

    [MaxLength(500)]
    public string? CompanyName { get; set; }

    [MaxLength(256)]
    public string? Email { get; set; }

    [MaxLength(500)]
    public string? Web { get; set; }

    [MaxLength(2500)]
    public string? Notes { get; set; }

    public bool IsActive { get; set; }

    public DateTime CreatedAt { get; set; }

    public DateTime ModifiedAt { get; set; }

    [Timestamp]
    public byte[] RowVersion { get; set; } = null!;

    public virtual ICollection<ContactAddress> ContactAddresses { get; set; } = new List<ContactAddress>();

    public virtual ICollection<ContactPhone> ContactPhones { get; set; } = new List<ContactPhone>();

    public virtual ICollection<ContactSearchTag> ContactSearchTags { get; set; } = new List<ContactSearchTag>();

    [ForeignKey(nameof(TenantId))]
    public virtual Tenant Tenant { get; set; } = null!;
}
