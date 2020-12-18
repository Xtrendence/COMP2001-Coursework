using System;
using System.Collections.Generic;

#nullable disable

namespace Auth.Models
{
    public partial class Session
    {
        public int userId { get; set; }
        public DateTime issueDate { get; set; }

        public virtual User User { get; set; }
    }
}
