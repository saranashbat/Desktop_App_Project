package qa.udst.perfume_shop;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ApplicationContext;
import qa.udst.perfume_shop.model.Perfume;
import qa.udst.perfume_shop.repository.PerfumeRepository;

@SpringBootApplication
public class PerfumeShopApplication {

    public static void main(String[] args) {
        ApplicationContext context = SpringApplication.run(PerfumeShopApplication.class, args);
        PerfumeRepository repo = context.getBean(PerfumeRepository.class);

        
    }
}
