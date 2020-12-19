using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace skoll.Dominio.Common
{
    public class Response
    {
        public string status { get; set; }
        public dynamic message { get; set; }
        public Response(string _status, dynamic _message)
        {
            status = _status;
            message = _message;
        }
    }
}
