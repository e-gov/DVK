package ee.ria.dhx.dvk;

import lombok.extern.slf4j.Slf4j;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Configurable;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import ee.ria.dhx.exception.DhxException;

@Slf4j
@Service
@Configurable
public class DvkDhxScheduler {
	
	@Autowired
	DvkDhxService dvkDhxService;
	
	  /**
	   * Sends documents periodically.
	   * 
	   * @throws DhxException - thrown if error occures while sending document
	   */
	  @Scheduled(cron = "${dhx_document_resend_timout}")
	  public void sendDvkDocuments() {
	      log.debug("sending DHX documents automatically");
	      dvkDhxService.sendDvkToDhx();
	  }

}
