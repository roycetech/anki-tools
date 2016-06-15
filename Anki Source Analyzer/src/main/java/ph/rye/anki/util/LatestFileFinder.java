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
package ph.rye.anki.util;

import java.io.File;
import java.io.FileFilter;
import java.text.SimpleDateFormat;
import java.util.Locale;

/**
 * @author royce
 *
 */
public class LatestFileFinder {

    private transient File rootPath;
    private transient String fileMask = "*.txt";
    private transient File lastModifiedFile;
    private transient File lastModifiedFolder;
    private transient long lastModifiedFiledate;


    public LatestFileFinder(final String rootPath) {
        this(rootPath, "*.txt");
    }

    public LatestFileFinder(final String rootPath, final String fileMask) {
        this.rootPath = new File(rootPath);
        this.fileMask = fileMask.replace("?", ".?").replace("*", ".*?");
    }


    public File find() {
        recurseFind(rootPath);

        System.out.println(
            String.format(
                "Last modified date/time: %s",
                new SimpleDateFormat("MM/dd/yyyy HH:mm", Locale.getDefault()),
                lastModifiedFiledate));

        return lastModifiedFile;
    }

    private void recurseFind(final File folder) {

        for (final File file : folder.listFiles(
            (FileFilter) pathname -> pathname.isFile()
                    && pathname.getAbsolutePath().matches(fileMask))) {
            if (lastModifiedFile == null
                    || file.lastModified() > lastModifiedFiledate) {
                lastModifiedFile = file;
                lastModifiedFolder = folder;
                lastModifiedFiledate = file.lastModified();
            }
        }

        for (final File subfolder : listFolder(folder)) {
            recurseFind(subfolder);
        }
    }

    private File[] listFolder(final File folder) {
        return folder.listFiles(
            (FileFilter) pathname -> pathname.isDirectory()
                    && !pathname.getName().equals("..")
                    && !pathname.getName().equals("."));
    }

    public File getLatestFolder() {
        return lastModifiedFolder;
    }

}


//# path = '/Users/royce/Dropbox/Documents/Reviewer'
//# puts LatestFileFinder.new(path).find
