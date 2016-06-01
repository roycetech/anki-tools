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
package ph.rye.anki.view;

import java.awt.GridBagConstraints;
import java.awt.Insets;

/**
 * @author royce
 *
 */
@SuppressWarnings("PMD.MissingStaticMethodInNonInstantiatableClass")
public class Constraint extends GridBagConstraints {

    /** */
    private static final long serialVersionUID = 3671976461279137323L;


    private Constraint(final Builder builder) {
        super();
        gridx = builder.gridx;
        gridy = builder.gridy;
        anchor = builder.anchor;
        fill = builder.fill;
        weightx = builder.weightx;
        weighty = builder.weighty;
        insets = builder.insets;
        gridwidth = builder.gridwidth;

    }

    @SuppressWarnings("PMD.AvoidFieldNameMatchingMethodName")
    public static class Builder {

        private transient int gridx = RELATIVE;
        private transient int gridy = RELATIVE;
        private transient int anchor = CENTER;
        private transient int fill = NONE;
        private transient int weightx;
        private transient int weighty;
        private transient Insets insets = new Insets(0, 0, 0, 0);;
        private transient int gridwidth = 1;


        public Builder gridx(final int gridx) {
            this.gridx = gridx;
            return this;
        }

        public Builder gridy(final int gridy) {
            this.gridy = gridy;
            return this;
        }

        public Builder anchor(final int anchor) {
            this.anchor = anchor;
            return this;
        }

        public Builder fill(final int fill) {
            this.fill = fill;
            return this;
        }

        public Builder weightx(final int weightx) {
            this.weightx = weightx;
            return this;
        }

        public Builder weighty(final int weighty) {
            this.weighty = weighty;
            return this;
        }

        public Builder insets(final Insets insets) {
            this.insets = insets;
            return this;
        }

        public Builder gridwidth(final int gridwidth) {
            this.gridwidth = gridwidth;
            return this;
        }

        @SuppressWarnings("PMD.AccessorClassGeneration")
        public GridBagConstraints build() {
            return new Constraint(this);
        }
    }


}
