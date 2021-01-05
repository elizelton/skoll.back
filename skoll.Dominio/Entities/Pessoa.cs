using skoll.Dominio.Common;
using skoll.Dominio.Enums;
using System.Collections.Generic;

namespace skoll.Dominio.Entities
{
    public class Pessoa : BaseEntity
    {
        public string cpfCnpj { get; set; }
        public string numero { get; set; }
        public string complemento { get; set; }
        public string bairro { get; set; }
        public string nome { get; set; }
        public string email { get; set; }
        public string cep { get; set; }
        public string logradouro { get; set; }
        public Cidade Cidade { get; set; }
        public List<Telefone> telefones { get; set; }
    }
}
