using System;

namespace MDMSApi2.Domain;

public interface IEntityBase
{
    int Id { get; set; }

    DateTime CreatedAt { get; set; }

    DateTime ModifiedAt { get; set; }
}
