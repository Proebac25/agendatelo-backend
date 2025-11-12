package com.proebac25.pwa_sql_java.repository;

import com.proebac25.pwa_sql_java.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
}
