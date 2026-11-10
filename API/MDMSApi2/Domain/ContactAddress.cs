using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MDMSApi2.Domain;

[Table("ContactAddress")]
public partial class ContactAddress : IEntityBase
{
    [Key]
    public int Id { get; set; }

    public int ContactId { get; set; }

    [MaxLength(200)]
    public string? Street1 { get; set; }

    [MaxLength(200)]
    public string? Street2 { get; set; }

    [MaxLength(100)]
    public string? City { get; set; }

    [MaxLength(100)]
    public string? County { get; set; }

    [MaxLength(100)]
    public string? State { get; set; }

    [MaxLength(20)]
    public string? Zip { get; set; }

    public bool IsActive { get; set; }

    public DateTime CreatedAt { get; set; }

    public DateTime ModifiedAt { get; set; }

    // Navigation property removed to avoid circular references when serializing child entities
}
// CreatedAt and ModifiedAt properties are present to satisfy IEntityBase requirements.
