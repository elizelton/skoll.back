using System.ComponentModel.DataAnnotations;

namespace skoll.Domain.Common
{
    public abstract class BaseEntity
    {
        [Key()]
        public int Id { get; set; }
    }
}
