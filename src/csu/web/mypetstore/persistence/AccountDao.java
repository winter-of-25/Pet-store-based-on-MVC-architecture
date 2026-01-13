package csu.web.mypetstore.persistence;

import csu.web.mypetstore.domain.Account;

public interface AccountDao {
    Account getAccountByUsername(String username) throws Exception;

    Account getAccountByUsernameAndPassword(Account account) throws Exception;

    void insertAccount(Account account) throws Exception;

    void insertProfile(Account account);

    void insertSignon(Account account);

    void updateAccount(Account account) throws Exception;

    void updateProfile(Account account);

    void updateSignon(Account account);
}