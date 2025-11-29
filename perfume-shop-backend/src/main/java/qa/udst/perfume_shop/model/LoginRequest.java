package qa.udst.perfume_shop.model;

import lombok.Data;

@Data
public class LoginRequest {
    private String email;
    private String password;
}
