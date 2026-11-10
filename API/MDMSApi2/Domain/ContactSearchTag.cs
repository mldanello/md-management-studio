using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MDMSApi2.Domain;

[Table("ContactSearchTag")]
public partial class ContactSearchTag : IEntityBase
{
    [Key]
    public int Id { get; set; }

    public int ContactId { get; set; }

    [MaxLength(50)]
    public string? TagText { get; set; }

    public bool IsActive { get; set; }

    public DateTime CreatedAt { get; set; }

    public DateTime ModifiedAt { get; set; }

    // Navigation property removed to avoid circular references when serializing child entities
}
