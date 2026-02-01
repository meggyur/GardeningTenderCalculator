namespace GardeningTenderCalculator.Data
{
    using System.Data;
    using Dapper;
    using Microsoft.Data.SqlClient;

    public class DataContextDapper
    {
        private readonly IConfiguration _config;

        public DataContextDapper(IConfiguration config)
        {
            _config = config;
        }
      

        public IEnumerable<T> LoadData<T>(string scl)
        {
            using IDbConnection dbConnection = new SqlConnection(_config.GetConnectionString("DefaultConnection"));

            return dbConnection.Query<T>(scl);
        }

        public T LoadDataSingle<T>(string scl)
        {
            using IDbConnection dbConnection = new SqlConnection(_config.GetConnectionString("DefaultConnection"));

            return dbConnection.QuerySingle<T>(scl);
        }

         public bool ExecuteSql<T>(string scl, object parameters)
        {
            using IDbConnection dbConnection = new SqlConnection(_config.GetConnectionString("DefaultConnection"));

            return dbConnection.Execute(scl, parameters) > 0;
        }

        public int ExecuteSqlWithRowCount<T>(string scl)
        {
            using IDbConnection dbConnection = new SqlConnection(_config.GetConnectionString("DefaultConnection"));

            return dbConnection.Execute(scl);
        }
    }
}