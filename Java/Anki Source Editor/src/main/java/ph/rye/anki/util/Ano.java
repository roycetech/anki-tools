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

/**
 * Another nice Object.
 *
 * Can be used to avoid re-assignment in the client code.
 *
 * @author royce
 */
public class Ano<T> {


    private transient T value;


    public Ano() {
        this(null);
    }

    public Ano(final T defaultValue) {
        value = defaultValue;
    }


    public void set(final T newValue) {
        value = newValue;
    }

    public T get() {
        return value;
    }


    @Override
    public String toString() {
        return value == null ? "null" : value.toString();
    }

}
