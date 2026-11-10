using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MDMSApi2.Domain;

[Table("ContactPhone")]
public partial class ContactPhone : IEntityBase
{
    [Key]
    public int Id { get; set; }

    public int ContactId { get; set; }

    [MaxLength(50)]
    public string Number { get; set; } = null!;

    [MaxLength(100)]
    public string? Type { get; set; }

    public bool IsPrimary { get; set; }

    public bool IsActive { get; set; }

    public DateTime CreatedAt { get; set; }

    public DateTime ModifiedAt { get; set; }

    // Navigation property removed to avoid circular references when serializing child entities
}
