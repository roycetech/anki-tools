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
package ph.rye.anki.model;

import java.io.BufferedReader;
import java.io.IOException;
import java.lang.reflect.Array;

/**
 * @author royce
 *
 */
public abstract class AbstractArrayedBuffReader<T> {


    private final transient BufferedReader reader;
    private final transient T[] objects;


    @SuppressWarnings("unchecked")
    public AbstractArrayedBuffReader(final BufferedReader reader,
            final Class<T> klass, final T... objects) {
        this.reader = reader;

        this.objects = (T[]) Array.newInstance(klass, objects.length);
        System.arraycopy(objects, 0, this.objects, 0, objects.length);

    }

    public abstract void next(String line);

    protected T get(final int i) {
        return objects[i];
    }

    public void eachLine() {
        try {
            String line = reader.readLine();
            while (line != null) {
                next(line);
                line = reader.readLine();
            }

        } catch (final IOException e) {
            throw new AbstractReaderException(e);
        }

    }

}

class AbstractReaderException extends RuntimeException {

    /** */
    private static final long serialVersionUID = 7856846846985673963L;

    public AbstractReaderException(final Throwable throwable) {
        super(throwable);
    }
}
