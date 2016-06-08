/**
 *   Copyright 2016 Royce Remulla
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */
package ph.rye.deckuploader;

import java.io.File;
import java.util.List;
import java.util.concurrent.TimeUnit;

import org.openqa.selenium.Alert;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.firefox.FirefoxDriver;

import ph.rye.common.lang.ResourceUtil;
import ph.rye.logging.OneLogger;

/**
 * @author royce
 *
 */
public class Main {


    private static final OneLogger LOG1 = OneLogger.getInstance();


    private static final WebDriver driver = new FirefoxDriver();;
    private final static String baseUrl = "https://api.ankiapp.com/";
    private final static StringBuffer verificationErrors = new StringBuffer();


    private final static String PATH =
            "/Users/royce/Desktop/Anki Generated Sources";


    public void execute() {
        driver.manage().timeouts().implicitlyWait(30, TimeUnit.SECONDS);

        driver.get(baseUrl + "nexus/");
        driver.findElement(By.cssSelector("input.flex-item")).clear();
        driver.findElement(By.cssSelector("input.flex-item")).sendKeys(
            ResourceUtil.getString("config", "username"));
        driver.findElement(By.xpath("//input[@type='password']")).clear();
        driver.findElement(By.xpath("//input[@type='password']")).sendKeys(
            ResourceUtil.getString("config", "password"));

        driver
            .findElement(By.cssSelector("form.auth.flex-container > div"))
            .click();

        pause(1, "Clicked logged in");


        final WebElement importElement = driver.findElement(
            By.cssSelector(
                "div.center:nth-child(1) > div:nth-child(4) > "
                        + "div:nth-child(1) > div:nth-child(2) > "
                        + "span:nth-child(1)"));

        LOG1.debug("Click " + importElement.getText());

        /* Import */
        importElement.click();
        pause(1);

        /* Import from Spreadsheet */
        driver.findElement(By.xpath("//div[3]/span")).click();
        pause(1, "Clicked Spreadsheet");

        final List<String> filenames =
                new FolderCrawler().getFiles(PATH, ".tsv");

        LOG1.debug("File count: " + filenames.size());

        for (final String filename : filenames) {
            LOG1.debug(filename);
            uploadFile(filename);
        }

        assert "".equals(verificationErrors.toString());
    }

    public void uploadFile(final String filename) {
        LOG1.info("Uploading file: " + filename);

        final WebElement fileElement = driver.findElement(By.name("deckFile"));
        fileElement.clear();
        fileElement.sendKeys(PATH + File.separator + filename);

        pause(1);

        final WebElement nameElement = driver.findElement(By.name("deckName"));
        nameElement.click();

        nameElement.clear();
        nameElement.sendKeys(
            filename.substring(
                filename.lastIndexOf(File.separator) + 1,
                filename.lastIndexOf('.')));
        driver.findElement(By.xpath("//form/div/div/div[2]/div")).click();

        pause(10);
        final Alert alert = driver.switchTo().alert();
        alert.dismiss();

    }


    public static void main(final String... args) {
        final Main main = new Main();
        main.execute();
        LOG1.info("Program End.");
    }


    public void pause(final int seconds, final String... message) {
        if (message != null && message.length > 0) {
            System.out.println(message[0]);
        }
        try {
            Thread.sleep(1000 * Math.abs(seconds));
        } catch (final InterruptedException e) {
            e.printStackTrace();
        }
    }
}
