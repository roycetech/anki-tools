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


/**
 *
 * @author royce
 */
public class Tag {


    private final String name;
    private transient boolean checked;
    private transient int count;


    public Tag(final String name, final boolean checked) {
        assert name != null;

        this.name = name;
        this.checked = checked;
    }

    /**
     * @return the name
     */
    public String getName() {
        return name;
    }

    /**
     * @return the show
     */
    public boolean isChecked() {
        return checked;
    }

    public void setChecked(final boolean state) {
        checked = state;
    }

    /**
     * @return the count
     */
    public int getCount() {
        return count;
    }

    /**
     * @param count the count to set
     */
    public void incrementCount() {
        count++;
    }

    @Override
    public String toString() {
        return getClass().getSimpleName() + "(" + checked + "," + name + ")";
    }

}
