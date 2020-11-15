using System;
using System.Collections.Generic;

#nullable disable

namespace Auth.Models
{
    public partial class Password
    {
        public int UserId { get; set; }
        public string OldPassword { get; set; }
        public DateTime ChangeDate { get; set; }

        public virtual User User { get; set; }
    }
}
