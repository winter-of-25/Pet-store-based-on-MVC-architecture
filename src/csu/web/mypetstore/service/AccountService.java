package csu.web.mypetstore.service;

import csu.web.mypetstore.domain.Account;
import csu.web.mypetstore.persistence.AccountDao;
import csu.web.mypetstore.persistence.impl.AccountDaoImpl;

public class AccountService {

    private AccountDao accountDao;

    public AccountService() {
        this.accountDao = new AccountDaoImpl();
    }

    // 原有的登录验证方法
    public Account getAccount(String username, String password) throws Exception {
        Account account = new Account();
        account.setUsername(username);
        account.setPassword(password);
        return accountDao.getAccountByUsernameAndPassword(account);
    }

    // --- 【新增】用于AJAX验证的方法 ---
    public Account getAccount(String username) throws Exception {
        // 注意：你需要确保 AccountDao 中有 getAccountByUsername 方法
        return accountDao.getAccountByUsername(username);
    }

    public void insertAccount(Account a) throws Exception {
        accountDao.insertAccount(a);
    }

    public void updateAccount(Account a) throws Exception {
        accountDao.updateAccount(a);
    }
}