using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MDMSApi2.Domain;

[Table("Tenant")]
// Resaved for build consistency
public partial class Tenant : IEntityBase
{
    [Key]
    public int Id { get; set; }

    [MaxLength(256)]
    public string Name { get; set; } = null!;

    [MaxLength(2500)]
    public string? Description { get; set; }

    public bool IsActive { get; set; }

    public DateTime CreatedAt { get; set; }

    public DateTime ModifiedAt { get; set; }

    public virtual ICollection<Contact> Contacts { get; set; } = new List<Contact>();
}
